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

constant SCENARIO_LENGTH : integer := 320;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (12,0,92,0,162,0,215,0,132,0,227,0,10,0,0,0,47,0,0,0,155,0,155,0,75,0,159,0,204,0,54,0,209,0,153,0,0,0,119,0,9,0,183,0,92,0,250,0,206,0,129,0,101,0,111,0,226,0,13,0,0,0,183,0,95,0,49,0,52,0,143,0,240,0,193,0,137,0,66,0,58,0,255,0,13,0,94,0,0,0,195,0,152,0,168,0,162,0,51,0,23,0,35,0,162,0,14,0,77,0,0,0,12,0,159,0,237,0,12,0,0,0,51,0,8,0,13,0,170,0,138,0,179,0,35,0,56,0,240,0,45,0,245,0,75,0,0,0,239,0,229,0,163,0,118,0,120,0,40,0,115,0,5,0,221,0,93,0,166,0,180,0,165,0,183,0,129,0,205,0,188,0,58,0,23,0,55,0,147,0,51,0,51,0,57,0,195,0,58,0,0,0,62,0,250,0,181,0,221,0,63,0,168,0,40,0,219,0,53,0,6,0,139,0,182,0,30,0,198,0,70,0,44,0,21,0,54,0,0,0,202,0,185,0,102,0,0,0,17,0,161,0,219,0,153,0,65,0,18,0,140,0,199,0,0,0,0,0,161,0,6,0,22,0,209,0,8,0,22,0,69,0,247,0,254,0,150,0,7,0,52,0,2,0,44,0,215,0,98,0,254,0,157,0,87,0,44,0,238,0,57,0,0,0,143,0,151,0,110,0,191,0,45,0,0,0,129,0,240,0,120,0,27,0,0,0,0,0,37,0,151,0,178,0,202,0,194,0,227,0,155,0,158,0,0,0,186,0,61,0,160,0,0,0,253,0,76,0,0,0,0,0,0,0,0,0,220,0,0,0,0,0,169,0,183,0,53,0,127,0,32,0,81,0,73,0,9,0,200,0,62,0,116,0,0,0,121,0,60,0,0,0,48,0,140,0,207,0,249,0,120,0,1,0,83,0,166,0,70,0,35,0,0,0,25,0,198,0,106,0,213,0,168,0,139,0,0,0,73,0,226,0,0,0,63,0,2,0,12,0,124,0,0,0,68,0,185,0,126,0,244,0,32,0,82,0,60,0,197,0,80,0,116,0,0,0,52,0,85,0,100,0,189,0,152,0,2,0,0,0,148,0,163,0,0,0,56,0,139,0,0,0,203,0,193,0,149,0,14,0,76,0,251,0,252,0,167,0,1,0,11,0,0,0,123,0,0,0,123,0,90,0,191,0,142,0,249,0,0,0,176,0,9,0,0,0,190,0,0,0,83,0,253,0,51,0,213,0,197,0,246,0,252,0,0,0,62,0,135,0,107,0,171,0,210,0,0,0,84,0,46,0,4,0,23,0,0,0,0,0,212,0,255,0,26,0,0,0,31,0,229,0,34,0,61,0,42,0,0,0,208,0,0,0,239,0,138,0,217,0,97,0,0,0,95,0,69,0,74,0);
signal scenario_full  : scenario_type := (12,31,92,31,162,31,215,31,132,31,227,31,10,31,10,30,47,31,47,30,155,31,155,31,75,31,159,31,204,31,54,31,209,31,153,31,153,30,119,31,9,31,183,31,92,31,250,31,206,31,129,31,101,31,111,31,226,31,13,31,13,30,183,31,95,31,49,31,52,31,143,31,240,31,193,31,137,31,66,31,58,31,255,31,13,31,94,31,94,30,195,31,152,31,168,31,162,31,51,31,23,31,35,31,162,31,14,31,77,31,77,30,12,31,159,31,237,31,12,31,12,30,51,31,8,31,13,31,170,31,138,31,179,31,35,31,56,31,240,31,45,31,245,31,75,31,75,30,239,31,229,31,163,31,118,31,120,31,40,31,115,31,5,31,221,31,93,31,166,31,180,31,165,31,183,31,129,31,205,31,188,31,58,31,23,31,55,31,147,31,51,31,51,31,57,31,195,31,58,31,58,30,62,31,250,31,181,31,221,31,63,31,168,31,40,31,219,31,53,31,6,31,139,31,182,31,30,31,198,31,70,31,44,31,21,31,54,31,54,30,202,31,185,31,102,31,102,30,17,31,161,31,219,31,153,31,65,31,18,31,140,31,199,31,199,30,199,29,161,31,6,31,22,31,209,31,8,31,22,31,69,31,247,31,254,31,150,31,7,31,52,31,2,31,44,31,215,31,98,31,254,31,157,31,87,31,44,31,238,31,57,31,57,30,143,31,151,31,110,31,191,31,45,31,45,30,129,31,240,31,120,31,27,31,27,30,27,29,37,31,151,31,178,31,202,31,194,31,227,31,155,31,158,31,158,30,186,31,61,31,160,31,160,30,253,31,76,31,76,30,76,29,76,28,76,27,220,31,220,30,220,29,169,31,183,31,53,31,127,31,32,31,81,31,73,31,9,31,200,31,62,31,116,31,116,30,121,31,60,31,60,30,48,31,140,31,207,31,249,31,120,31,1,31,83,31,166,31,70,31,35,31,35,30,25,31,198,31,106,31,213,31,168,31,139,31,139,30,73,31,226,31,226,30,63,31,2,31,12,31,124,31,124,30,68,31,185,31,126,31,244,31,32,31,82,31,60,31,197,31,80,31,116,31,116,30,52,31,85,31,100,31,189,31,152,31,2,31,2,30,148,31,163,31,163,30,56,31,139,31,139,30,203,31,193,31,149,31,14,31,76,31,251,31,252,31,167,31,1,31,11,31,11,30,123,31,123,30,123,31,90,31,191,31,142,31,249,31,249,30,176,31,9,31,9,30,190,31,190,30,83,31,253,31,51,31,213,31,197,31,246,31,252,31,252,30,62,31,135,31,107,31,171,31,210,31,210,30,84,31,46,31,4,31,23,31,23,30,23,29,212,31,255,31,26,31,26,30,31,31,229,31,34,31,61,31,42,31,42,30,208,31,208,30,239,31,138,31,217,31,97,31,97,30,95,31,69,31,74,31);

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
