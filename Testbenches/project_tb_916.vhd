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

constant SCENARIO_LENGTH : integer := 259;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (216,0,97,0,123,0,110,0,63,0,200,0,221,0,0,0,50,0,84,0,154,0,89,0,242,0,0,0,171,0,0,0,43,0,178,0,148,0,203,0,149,0,33,0,197,0,46,0,208,0,219,0,57,0,140,0,0,0,0,0,238,0,235,0,36,0,254,0,201,0,196,0,92,0,83,0,0,0,118,0,141,0,57,0,126,0,76,0,212,0,91,0,253,0,0,0,181,0,248,0,232,0,147,0,132,0,65,0,138,0,79,0,1,0,75,0,154,0,30,0,127,0,27,0,165,0,0,0,0,0,235,0,183,0,249,0,50,0,175,0,107,0,19,0,184,0,108,0,225,0,96,0,0,0,21,0,0,0,32,0,183,0,16,0,71,0,0,0,144,0,55,0,233,0,59,0,205,0,190,0,0,0,65,0,32,0,0,0,72,0,149,0,1,0,237,0,0,0,180,0,52,0,69,0,20,0,160,0,179,0,195,0,149,0,89,0,0,0,0,0,143,0,45,0,3,0,162,0,226,0,199,0,0,0,31,0,158,0,62,0,0,0,121,0,124,0,34,0,30,0,111,0,213,0,192,0,172,0,178,0,223,0,244,0,234,0,112,0,243,0,251,0,134,0,27,0,0,0,216,0,15,0,220,0,116,0,0,0,246,0,0,0,9,0,174,0,0,0,168,0,0,0,4,0,90,0,255,0,50,0,56,0,0,0,85,0,11,0,0,0,194,0,0,0,254,0,64,0,167,0,45,0,50,0,246,0,0,0,166,0,194,0,233,0,50,0,113,0,0,0,112,0,120,0,0,0,84,0,252,0,232,0,73,0,0,0,0,0,60,0,33,0,9,0,204,0,0,0,229,0,0,0,84,0,14,0,226,0,0,0,3,0,143,0,0,0,211,0,155,0,187,0,0,0,0,0,255,0,177,0,212,0,213,0,115,0,110,0,185,0,130,0,64,0,98,0,221,0,227,0,220,0,0,0,37,0,59,0,55,0,168,0,169,0,163,0,0,0,0,0,161,0,232,0,122,0,0,0,192,0,96,0,24,0,142,0,0,0,212,0,0,0,0,0,81,0,78,0,0,0,128,0,0,0,0,0,0,0,204,0,235,0,127,0,0,0,142,0,85,0,47,0,160,0,210,0,0,0,97,0,1,0,213,0,33,0,31,0);
signal scenario_full  : scenario_type := (216,31,97,31,123,31,110,31,63,31,200,31,221,31,221,30,50,31,84,31,154,31,89,31,242,31,242,30,171,31,171,30,43,31,178,31,148,31,203,31,149,31,33,31,197,31,46,31,208,31,219,31,57,31,140,31,140,30,140,29,238,31,235,31,36,31,254,31,201,31,196,31,92,31,83,31,83,30,118,31,141,31,57,31,126,31,76,31,212,31,91,31,253,31,253,30,181,31,248,31,232,31,147,31,132,31,65,31,138,31,79,31,1,31,75,31,154,31,30,31,127,31,27,31,165,31,165,30,165,29,235,31,183,31,249,31,50,31,175,31,107,31,19,31,184,31,108,31,225,31,96,31,96,30,21,31,21,30,32,31,183,31,16,31,71,31,71,30,144,31,55,31,233,31,59,31,205,31,190,31,190,30,65,31,32,31,32,30,72,31,149,31,1,31,237,31,237,30,180,31,52,31,69,31,20,31,160,31,179,31,195,31,149,31,89,31,89,30,89,29,143,31,45,31,3,31,162,31,226,31,199,31,199,30,31,31,158,31,62,31,62,30,121,31,124,31,34,31,30,31,111,31,213,31,192,31,172,31,178,31,223,31,244,31,234,31,112,31,243,31,251,31,134,31,27,31,27,30,216,31,15,31,220,31,116,31,116,30,246,31,246,30,9,31,174,31,174,30,168,31,168,30,4,31,90,31,255,31,50,31,56,31,56,30,85,31,11,31,11,30,194,31,194,30,254,31,64,31,167,31,45,31,50,31,246,31,246,30,166,31,194,31,233,31,50,31,113,31,113,30,112,31,120,31,120,30,84,31,252,31,232,31,73,31,73,30,73,29,60,31,33,31,9,31,204,31,204,30,229,31,229,30,84,31,14,31,226,31,226,30,3,31,143,31,143,30,211,31,155,31,187,31,187,30,187,29,255,31,177,31,212,31,213,31,115,31,110,31,185,31,130,31,64,31,98,31,221,31,227,31,220,31,220,30,37,31,59,31,55,31,168,31,169,31,163,31,163,30,163,29,161,31,232,31,122,31,122,30,192,31,96,31,24,31,142,31,142,30,212,31,212,30,212,29,81,31,78,31,78,30,128,31,128,30,128,29,128,28,204,31,235,31,127,31,127,30,142,31,85,31,47,31,160,31,210,31,210,30,97,31,1,31,213,31,33,31,31,31);

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
