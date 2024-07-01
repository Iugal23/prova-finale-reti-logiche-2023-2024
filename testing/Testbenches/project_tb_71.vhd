-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_71 is
end project_tb_71;

architecture project_tb_arch_71 of project_tb_71 is
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

constant SCENARIO_LENGTH : integer := 324;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,194,0,217,0,4,0,197,0,0,0,124,0,197,0,235,0,96,0,0,0,105,0,225,0,83,0,218,0,176,0,198,0,0,0,0,0,37,0,183,0,208,0,63,0,251,0,0,0,50,0,0,0,0,0,199,0,26,0,0,0,0,0,101,0,254,0,0,0,252,0,0,0,180,0,91,0,137,0,140,0,0,0,129,0,166,0,0,0,117,0,6,0,0,0,238,0,89,0,0,0,211,0,57,0,196,0,0,0,90,0,183,0,74,0,0,0,55,0,117,0,164,0,225,0,250,0,91,0,221,0,123,0,0,0,64,0,0,0,60,0,0,0,13,0,189,0,189,0,156,0,30,0,86,0,0,0,170,0,76,0,187,0,63,0,0,0,113,0,217,0,0,0,230,0,224,0,195,0,205,0,42,0,53,0,230,0,0,0,2,0,2,0,0,0,100,0,208,0,187,0,71,0,166,0,198,0,187,0,137,0,243,0,0,0,0,0,249,0,0,0,217,0,21,0,167,0,0,0,189,0,0,0,9,0,74,0,247,0,157,0,218,0,80,0,236,0,0,0,0,0,76,0,215,0,0,0,205,0,51,0,153,0,0,0,61,0,69,0,126,0,123,0,190,0,81,0,86,0,0,0,109,0,87,0,253,0,225,0,41,0,0,0,186,0,246,0,186,0,50,0,0,0,0,0,68,0,233,0,141,0,131,0,135,0,32,0,217,0,0,0,187,0,92,0,90,0,100,0,14,0,165,0,206,0,154,0,78,0,164,0,168,0,170,0,251,0,153,0,217,0,99,0,144,0,211,0,98,0,197,0,117,0,0,0,126,0,187,0,11,0,140,0,126,0,180,0,0,0,0,0,111,0,85,0,0,0,0,0,0,0,0,0,34,0,122,0,112,0,0,0,82,0,0,0,190,0,117,0,149,0,0,0,239,0,165,0,7,0,40,0,0,0,229,0,133,0,216,0,235,0,91,0,177,0,55,0,0,0,0,0,30,0,210,0,8,0,166,0,208,0,48,0,155,0,56,0,214,0,18,0,237,0,61,0,212,0,63,0,249,0,214,0,73,0,194,0,37,0,102,0,0,0,224,0,0,0,79,0,21,0,232,0,5,0,50,0,64,0,244,0,187,0,176,0,0,0,168,0,3,0,251,0,6,0,0,0,250,0,101,0,58,0,215,0,94,0,180,0,152,0,146,0,0,0,201,0,138,0,55,0,183,0,135,0,245,0,58,0,0,0,0,0,25,0,0,0,0,0,129,0,145,0,0,0,197,0,0,0,189,0,101,0,180,0,74,0,132,0,102,0,129,0,210,0,143,0,91,0,93,0,198,0,0,0,240,0,160,0,0,0,0,0,0,0,0,0,72,0,0,0,184,0,0,0,0,0,202,0,184,0,63,0,0,0,31,0,82,0,50,0,0,0,90,0,99,0,7,0,143,0,235,0,0,0,208,0);
signal scenario_full  : scenario_type := (0,0,194,31,217,31,4,31,197,31,197,30,124,31,197,31,235,31,96,31,96,30,105,31,225,31,83,31,218,31,176,31,198,31,198,30,198,29,37,31,183,31,208,31,63,31,251,31,251,30,50,31,50,30,50,29,199,31,26,31,26,30,26,29,101,31,254,31,254,30,252,31,252,30,180,31,91,31,137,31,140,31,140,30,129,31,166,31,166,30,117,31,6,31,6,30,238,31,89,31,89,30,211,31,57,31,196,31,196,30,90,31,183,31,74,31,74,30,55,31,117,31,164,31,225,31,250,31,91,31,221,31,123,31,123,30,64,31,64,30,60,31,60,30,13,31,189,31,189,31,156,31,30,31,86,31,86,30,170,31,76,31,187,31,63,31,63,30,113,31,217,31,217,30,230,31,224,31,195,31,205,31,42,31,53,31,230,31,230,30,2,31,2,31,2,30,100,31,208,31,187,31,71,31,166,31,198,31,187,31,137,31,243,31,243,30,243,29,249,31,249,30,217,31,21,31,167,31,167,30,189,31,189,30,9,31,74,31,247,31,157,31,218,31,80,31,236,31,236,30,236,29,76,31,215,31,215,30,205,31,51,31,153,31,153,30,61,31,69,31,126,31,123,31,190,31,81,31,86,31,86,30,109,31,87,31,253,31,225,31,41,31,41,30,186,31,246,31,186,31,50,31,50,30,50,29,68,31,233,31,141,31,131,31,135,31,32,31,217,31,217,30,187,31,92,31,90,31,100,31,14,31,165,31,206,31,154,31,78,31,164,31,168,31,170,31,251,31,153,31,217,31,99,31,144,31,211,31,98,31,197,31,117,31,117,30,126,31,187,31,11,31,140,31,126,31,180,31,180,30,180,29,111,31,85,31,85,30,85,29,85,28,85,27,34,31,122,31,112,31,112,30,82,31,82,30,190,31,117,31,149,31,149,30,239,31,165,31,7,31,40,31,40,30,229,31,133,31,216,31,235,31,91,31,177,31,55,31,55,30,55,29,30,31,210,31,8,31,166,31,208,31,48,31,155,31,56,31,214,31,18,31,237,31,61,31,212,31,63,31,249,31,214,31,73,31,194,31,37,31,102,31,102,30,224,31,224,30,79,31,21,31,232,31,5,31,50,31,64,31,244,31,187,31,176,31,176,30,168,31,3,31,251,31,6,31,6,30,250,31,101,31,58,31,215,31,94,31,180,31,152,31,146,31,146,30,201,31,138,31,55,31,183,31,135,31,245,31,58,31,58,30,58,29,25,31,25,30,25,29,129,31,145,31,145,30,197,31,197,30,189,31,101,31,180,31,74,31,132,31,102,31,129,31,210,31,143,31,91,31,93,31,198,31,198,30,240,31,160,31,160,30,160,29,160,28,160,27,72,31,72,30,184,31,184,30,184,29,202,31,184,31,63,31,63,30,31,31,82,31,50,31,50,30,90,31,99,31,7,31,143,31,235,31,235,30,208,31);

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
