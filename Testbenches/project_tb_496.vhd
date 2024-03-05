-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 317;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (139,0,21,0,111,0,226,0,124,0,149,0,58,0,11,0,168,0,123,0,202,0,58,0,7,0,137,0,0,0,37,0,6,0,226,0,145,0,222,0,138,0,235,0,119,0,148,0,177,0,124,0,52,0,169,0,60,0,158,0,206,0,119,0,233,0,227,0,115,0,194,0,0,0,26,0,122,0,97,0,168,0,0,0,0,0,170,0,248,0,95,0,14,0,231,0,144,0,94,0,0,0,141,0,210,0,210,0,132,0,43,0,56,0,72,0,120,0,44,0,235,0,150,0,129,0,105,0,219,0,0,0,252,0,31,0,140,0,133,0,162,0,150,0,8,0,10,0,108,0,0,0,58,0,123,0,131,0,0,0,0,0,81,0,138,0,82,0,93,0,151,0,43,0,179,0,235,0,178,0,244,0,22,0,209,0,119,0,246,0,4,0,135,0,155,0,0,0,136,0,142,0,210,0,164,0,166,0,211,0,213,0,135,0,53,0,105,0,61,0,197,0,0,0,0,0,0,0,215,0,0,0,49,0,88,0,122,0,110,0,100,0,0,0,221,0,37,0,26,0,104,0,167,0,0,0,34,0,0,0,28,0,22,0,177,0,231,0,0,0,234,0,0,0,25,0,0,0,0,0,0,0,130,0,0,0,0,0,200,0,24,0,196,0,163,0,188,0,0,0,28,0,195,0,98,0,0,0,0,0,126,0,85,0,182,0,48,0,236,0,216,0,74,0,178,0,31,0,0,0,203,0,0,0,116,0,107,0,185,0,84,0,13,0,0,0,105,0,226,0,166,0,9,0,0,0,100,0,0,0,0,0,216,0,7,0,0,0,144,0,141,0,158,0,108,0,150,0,171,0,121,0,70,0,90,0,181,0,174,0,162,0,38,0,0,0,197,0,160,0,199,0,57,0,48,0,89,0,0,0,214,0,218,0,102,0,196,0,0,0,249,0,189,0,113,0,46,0,174,0,38,0,192,0,209,0,177,0,121,0,0,0,228,0,222,0,167,0,40,0,232,0,0,0,0,0,77,0,36,0,68,0,24,0,0,0,162,0,237,0,59,0,111,0,42,0,195,0,58,0,72,0,216,0,77,0,41,0,238,0,0,0,71,0,149,0,162,0,0,0,36,0,89,0,14,0,137,0,27,0,16,0,130,0,92,0,6,0,52,0,138,0,52,0,0,0,0,0,141,0,0,0,195,0,109,0,185,0,60,0,99,0,217,0,108,0,0,0,46,0,87,0,2,0,200,0,79,0,161,0,25,0,0,0,184,0,182,0,0,0,0,0,0,0,0,0,255,0,253,0,250,0,175,0,58,0,10,0,243,0,108,0,162,0,163,0,16,0,73,0,212,0,51,0,130,0,201,0,124,0,183,0,199,0,117,0,165,0,217,0,3,0,10,0,0,0,119,0,218,0,31,0,152,0);
signal scenario_full  : scenario_type := (139,31,21,31,111,31,226,31,124,31,149,31,58,31,11,31,168,31,123,31,202,31,58,31,7,31,137,31,137,30,37,31,6,31,226,31,145,31,222,31,138,31,235,31,119,31,148,31,177,31,124,31,52,31,169,31,60,31,158,31,206,31,119,31,233,31,227,31,115,31,194,31,194,30,26,31,122,31,97,31,168,31,168,30,168,29,170,31,248,31,95,31,14,31,231,31,144,31,94,31,94,30,141,31,210,31,210,31,132,31,43,31,56,31,72,31,120,31,44,31,235,31,150,31,129,31,105,31,219,31,219,30,252,31,31,31,140,31,133,31,162,31,150,31,8,31,10,31,108,31,108,30,58,31,123,31,131,31,131,30,131,29,81,31,138,31,82,31,93,31,151,31,43,31,179,31,235,31,178,31,244,31,22,31,209,31,119,31,246,31,4,31,135,31,155,31,155,30,136,31,142,31,210,31,164,31,166,31,211,31,213,31,135,31,53,31,105,31,61,31,197,31,197,30,197,29,197,28,215,31,215,30,49,31,88,31,122,31,110,31,100,31,100,30,221,31,37,31,26,31,104,31,167,31,167,30,34,31,34,30,28,31,22,31,177,31,231,31,231,30,234,31,234,30,25,31,25,30,25,29,25,28,130,31,130,30,130,29,200,31,24,31,196,31,163,31,188,31,188,30,28,31,195,31,98,31,98,30,98,29,126,31,85,31,182,31,48,31,236,31,216,31,74,31,178,31,31,31,31,30,203,31,203,30,116,31,107,31,185,31,84,31,13,31,13,30,105,31,226,31,166,31,9,31,9,30,100,31,100,30,100,29,216,31,7,31,7,30,144,31,141,31,158,31,108,31,150,31,171,31,121,31,70,31,90,31,181,31,174,31,162,31,38,31,38,30,197,31,160,31,199,31,57,31,48,31,89,31,89,30,214,31,218,31,102,31,196,31,196,30,249,31,189,31,113,31,46,31,174,31,38,31,192,31,209,31,177,31,121,31,121,30,228,31,222,31,167,31,40,31,232,31,232,30,232,29,77,31,36,31,68,31,24,31,24,30,162,31,237,31,59,31,111,31,42,31,195,31,58,31,72,31,216,31,77,31,41,31,238,31,238,30,71,31,149,31,162,31,162,30,36,31,89,31,14,31,137,31,27,31,16,31,130,31,92,31,6,31,52,31,138,31,52,31,52,30,52,29,141,31,141,30,195,31,109,31,185,31,60,31,99,31,217,31,108,31,108,30,46,31,87,31,2,31,200,31,79,31,161,31,25,31,25,30,184,31,182,31,182,30,182,29,182,28,182,27,255,31,253,31,250,31,175,31,58,31,10,31,243,31,108,31,162,31,163,31,16,31,73,31,212,31,51,31,130,31,201,31,124,31,183,31,199,31,117,31,165,31,217,31,3,31,10,31,10,30,119,31,218,31,31,31,152,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
