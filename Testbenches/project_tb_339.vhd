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

constant SCENARIO_LENGTH : integer := 312;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (222,0,42,0,252,0,155,0,199,0,241,0,72,0,29,0,147,0,118,0,60,0,162,0,3,0,73,0,4,0,47,0,12,0,59,0,0,0,76,0,88,0,118,0,190,0,15,0,41,0,20,0,48,0,174,0,112,0,0,0,43,0,148,0,0,0,0,0,0,0,0,0,101,0,174,0,122,0,0,0,122,0,123,0,0,0,68,0,153,0,221,0,216,0,199,0,168,0,34,0,0,0,247,0,224,0,90,0,210,0,39,0,0,0,0,0,85,0,202,0,191,0,52,0,93,0,90,0,136,0,0,0,218,0,207,0,214,0,9,0,216,0,0,0,162,0,114,0,1,0,59,0,216,0,246,0,49,0,213,0,66,0,184,0,156,0,161,0,31,0,0,0,187,0,71,0,124,0,105,0,11,0,59,0,62,0,101,0,0,0,90,0,7,0,30,0,17,0,3,0,217,0,0,0,101,0,0,0,62,0,45,0,75,0,0,0,218,0,255,0,90,0,75,0,78,0,186,0,98,0,183,0,36,0,128,0,47,0,61,0,153,0,61,0,36,0,9,0,206,0,207,0,115,0,248,0,0,0,96,0,184,0,105,0,42,0,52,0,179,0,218,0,173,0,37,0,97,0,55,0,65,0,183,0,238,0,43,0,255,0,216,0,100,0,94,0,114,0,37,0,251,0,0,0,111,0,11,0,62,0,0,0,148,0,0,0,140,0,51,0,93,0,143,0,30,0,149,0,117,0,0,0,212,0,172,0,0,0,201,0,66,0,221,0,230,0,0,0,213,0,116,0,67,0,38,0,238,0,196,0,181,0,126,0,140,0,14,0,196,0,211,0,101,0,131,0,105,0,172,0,182,0,0,0,107,0,218,0,163,0,121,0,164,0,116,0,172,0,215,0,121,0,150,0,165,0,119,0,27,0,76,0,197,0,0,0,189,0,226,0,12,0,253,0,84,0,0,0,77,0,0,0,124,0,131,0,188,0,135,0,105,0,193,0,163,0,206,0,7,0,223,0,83,0,45,0,0,0,49,0,0,0,0,0,38,0,64,0,130,0,199,0,209,0,219,0,28,0,0,0,0,0,24,0,94,0,121,0,209,0,2,0,99,0,172,0,94,0,0,0,156,0,148,0,151,0,37,0,253,0,106,0,92,0,87,0,0,0,78,0,24,0,0,0,54,0,91,0,0,0,145,0,116,0,13,0,27,0,71,0,54,0,0,0,214,0,227,0,89,0,177,0,69,0,113,0,118,0,143,0,101,0,236,0,249,0,0,0,106,0,165,0,133,0,244,0,0,0,93,0,133,0,127,0,108,0,238,0,177,0,197,0,45,0,0,0,186,0,0,0,153,0,216,0,81,0,0,0,164,0,189,0,254,0,116,0,237,0,0,0,53,0,133,0);
signal scenario_full  : scenario_type := (222,31,42,31,252,31,155,31,199,31,241,31,72,31,29,31,147,31,118,31,60,31,162,31,3,31,73,31,4,31,47,31,12,31,59,31,59,30,76,31,88,31,118,31,190,31,15,31,41,31,20,31,48,31,174,31,112,31,112,30,43,31,148,31,148,30,148,29,148,28,148,27,101,31,174,31,122,31,122,30,122,31,123,31,123,30,68,31,153,31,221,31,216,31,199,31,168,31,34,31,34,30,247,31,224,31,90,31,210,31,39,31,39,30,39,29,85,31,202,31,191,31,52,31,93,31,90,31,136,31,136,30,218,31,207,31,214,31,9,31,216,31,216,30,162,31,114,31,1,31,59,31,216,31,246,31,49,31,213,31,66,31,184,31,156,31,161,31,31,31,31,30,187,31,71,31,124,31,105,31,11,31,59,31,62,31,101,31,101,30,90,31,7,31,30,31,17,31,3,31,217,31,217,30,101,31,101,30,62,31,45,31,75,31,75,30,218,31,255,31,90,31,75,31,78,31,186,31,98,31,183,31,36,31,128,31,47,31,61,31,153,31,61,31,36,31,9,31,206,31,207,31,115,31,248,31,248,30,96,31,184,31,105,31,42,31,52,31,179,31,218,31,173,31,37,31,97,31,55,31,65,31,183,31,238,31,43,31,255,31,216,31,100,31,94,31,114,31,37,31,251,31,251,30,111,31,11,31,62,31,62,30,148,31,148,30,140,31,51,31,93,31,143,31,30,31,149,31,117,31,117,30,212,31,172,31,172,30,201,31,66,31,221,31,230,31,230,30,213,31,116,31,67,31,38,31,238,31,196,31,181,31,126,31,140,31,14,31,196,31,211,31,101,31,131,31,105,31,172,31,182,31,182,30,107,31,218,31,163,31,121,31,164,31,116,31,172,31,215,31,121,31,150,31,165,31,119,31,27,31,76,31,197,31,197,30,189,31,226,31,12,31,253,31,84,31,84,30,77,31,77,30,124,31,131,31,188,31,135,31,105,31,193,31,163,31,206,31,7,31,223,31,83,31,45,31,45,30,49,31,49,30,49,29,38,31,64,31,130,31,199,31,209,31,219,31,28,31,28,30,28,29,24,31,94,31,121,31,209,31,2,31,99,31,172,31,94,31,94,30,156,31,148,31,151,31,37,31,253,31,106,31,92,31,87,31,87,30,78,31,24,31,24,30,54,31,91,31,91,30,145,31,116,31,13,31,27,31,71,31,54,31,54,30,214,31,227,31,89,31,177,31,69,31,113,31,118,31,143,31,101,31,236,31,249,31,249,30,106,31,165,31,133,31,244,31,244,30,93,31,133,31,127,31,108,31,238,31,177,31,197,31,45,31,45,30,186,31,186,30,153,31,216,31,81,31,81,30,164,31,189,31,254,31,116,31,237,31,237,30,53,31,133,31);

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
