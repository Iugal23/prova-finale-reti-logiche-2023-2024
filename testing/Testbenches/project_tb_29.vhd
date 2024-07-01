-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_29 is
end project_tb_29;

architecture project_tb_arch_29 of project_tb_29 is
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

constant SCENARIO_LENGTH : integer := 426;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (118,0,237,0,198,0,89,0,224,0,216,0,129,0,168,0,44,0,88,0,23,0,231,0,155,0,202,0,132,0,0,0,67,0,205,0,0,0,57,0,0,0,118,0,153,0,202,0,208,0,2,0,220,0,79,0,89,0,155,0,239,0,0,0,97,0,0,0,122,0,202,0,54,0,60,0,47,0,214,0,191,0,51,0,42,0,0,0,106,0,206,0,96,0,79,0,150,0,40,0,252,0,208,0,0,0,0,0,197,0,7,0,77,0,202,0,27,0,101,0,188,0,127,0,121,0,31,0,0,0,5,0,104,0,0,0,214,0,87,0,125,0,228,0,166,0,20,0,12,0,47,0,21,0,32,0,166,0,173,0,188,0,237,0,30,0,0,0,22,0,145,0,45,0,109,0,245,0,136,0,0,0,0,0,45,0,0,0,71,0,145,0,0,0,98,0,235,0,171,0,142,0,0,0,0,0,206,0,67,0,207,0,222,0,27,0,162,0,207,0,130,0,2,0,124,0,135,0,0,0,165,0,0,0,132,0,15,0,209,0,144,0,208,0,110,0,61,0,247,0,198,0,96,0,11,0,0,0,184,0,110,0,196,0,40,0,185,0,0,0,166,0,0,0,49,0,241,0,170,0,137,0,92,0,22,0,200,0,0,0,59,0,115,0,219,0,247,0,160,0,87,0,70,0,61,0,249,0,143,0,6,0,214,0,174,0,193,0,9,0,232,0,205,0,0,0,116,0,99,0,102,0,226,0,234,0,176,0,37,0,96,0,232,0,223,0,29,0,212,0,117,0,5,0,194,0,249,0,175,0,152,0,100,0,87,0,200,0,16,0,0,0,79,0,95,0,116,0,125,0,0,0,0,0,187,0,118,0,65,0,56,0,200,0,94,0,14,0,0,0,141,0,82,0,0,0,158,0,155,0,119,0,0,0,232,0,184,0,0,0,0,0,58,0,0,0,137,0,129,0,144,0,0,0,220,0,155,0,110,0,12,0,166,0,0,0,93,0,49,0,0,0,91,0,98,0,0,0,55,0,253,0,224,0,68,0,124,0,0,0,0,0,215,0,224,0,84,0,0,0,110,0,137,0,69,0,109,0,31,0,145,0,30,0,75,0,232,0,226,0,228,0,235,0,171,0,109,0,103,0,157,0,0,0,92,0,53,0,9,0,0,0,92,0,0,0,135,0,250,0,166,0,195,0,195,0,0,0,73,0,0,0,21,0,47,0,155,0,236,0,198,0,167,0,104,0,131,0,0,0,0,0,7,0,164,0,0,0,146,0,210,0,0,0,74,0,117,0,0,0,252,0,220,0,62,0,3,0,28,0,0,0,52,0,242,0,148,0,213,0,0,0,238,0,0,0,32,0,56,0,0,0,0,0,25,0,71,0,112,0,128,0,183,0,0,0,155,0,191,0,35,0,15,0,117,0,84,0,39,0,171,0,161,0,60,0,23,0,196,0,0,0,111,0,63,0,105,0,159,0,19,0,114,0,10,0,45,0,3,0,141,0,208,0,77,0,0,0,49,0,221,0,81,0,28,0,136,0,242,0,61,0,169,0,0,0,73,0,74,0,16,0,0,0,26,0,73,0,71,0,139,0,36,0,193,0,67,0,139,0,211,0,77,0,20,0,241,0,139,0,34,0,0,0,76,0,183,0,0,0,167,0,56,0,242,0,140,0,140,0,0,0,0,0,0,0,158,0,116,0,0,0,64,0,55,0,152,0,90,0,210,0,189,0,72,0,216,0,50,0,145,0,0,0,100,0,69,0,0,0,0,0,14,0,0,0,41,0,0,0,134,0,124,0,43,0,54,0,60,0,166,0,1,0,36,0,3,0,103,0,0,0,67,0,43,0,198,0,107,0,0,0,179,0,172,0,0,0,182,0,92,0,76,0,61,0,94,0,88,0,212,0);
signal scenario_full  : scenario_type := (118,31,237,31,198,31,89,31,224,31,216,31,129,31,168,31,44,31,88,31,23,31,231,31,155,31,202,31,132,31,132,30,67,31,205,31,205,30,57,31,57,30,118,31,153,31,202,31,208,31,2,31,220,31,79,31,89,31,155,31,239,31,239,30,97,31,97,30,122,31,202,31,54,31,60,31,47,31,214,31,191,31,51,31,42,31,42,30,106,31,206,31,96,31,79,31,150,31,40,31,252,31,208,31,208,30,208,29,197,31,7,31,77,31,202,31,27,31,101,31,188,31,127,31,121,31,31,31,31,30,5,31,104,31,104,30,214,31,87,31,125,31,228,31,166,31,20,31,12,31,47,31,21,31,32,31,166,31,173,31,188,31,237,31,30,31,30,30,22,31,145,31,45,31,109,31,245,31,136,31,136,30,136,29,45,31,45,30,71,31,145,31,145,30,98,31,235,31,171,31,142,31,142,30,142,29,206,31,67,31,207,31,222,31,27,31,162,31,207,31,130,31,2,31,124,31,135,31,135,30,165,31,165,30,132,31,15,31,209,31,144,31,208,31,110,31,61,31,247,31,198,31,96,31,11,31,11,30,184,31,110,31,196,31,40,31,185,31,185,30,166,31,166,30,49,31,241,31,170,31,137,31,92,31,22,31,200,31,200,30,59,31,115,31,219,31,247,31,160,31,87,31,70,31,61,31,249,31,143,31,6,31,214,31,174,31,193,31,9,31,232,31,205,31,205,30,116,31,99,31,102,31,226,31,234,31,176,31,37,31,96,31,232,31,223,31,29,31,212,31,117,31,5,31,194,31,249,31,175,31,152,31,100,31,87,31,200,31,16,31,16,30,79,31,95,31,116,31,125,31,125,30,125,29,187,31,118,31,65,31,56,31,200,31,94,31,14,31,14,30,141,31,82,31,82,30,158,31,155,31,119,31,119,30,232,31,184,31,184,30,184,29,58,31,58,30,137,31,129,31,144,31,144,30,220,31,155,31,110,31,12,31,166,31,166,30,93,31,49,31,49,30,91,31,98,31,98,30,55,31,253,31,224,31,68,31,124,31,124,30,124,29,215,31,224,31,84,31,84,30,110,31,137,31,69,31,109,31,31,31,145,31,30,31,75,31,232,31,226,31,228,31,235,31,171,31,109,31,103,31,157,31,157,30,92,31,53,31,9,31,9,30,92,31,92,30,135,31,250,31,166,31,195,31,195,31,195,30,73,31,73,30,21,31,47,31,155,31,236,31,198,31,167,31,104,31,131,31,131,30,131,29,7,31,164,31,164,30,146,31,210,31,210,30,74,31,117,31,117,30,252,31,220,31,62,31,3,31,28,31,28,30,52,31,242,31,148,31,213,31,213,30,238,31,238,30,32,31,56,31,56,30,56,29,25,31,71,31,112,31,128,31,183,31,183,30,155,31,191,31,35,31,15,31,117,31,84,31,39,31,171,31,161,31,60,31,23,31,196,31,196,30,111,31,63,31,105,31,159,31,19,31,114,31,10,31,45,31,3,31,141,31,208,31,77,31,77,30,49,31,221,31,81,31,28,31,136,31,242,31,61,31,169,31,169,30,73,31,74,31,16,31,16,30,26,31,73,31,71,31,139,31,36,31,193,31,67,31,139,31,211,31,77,31,20,31,241,31,139,31,34,31,34,30,76,31,183,31,183,30,167,31,56,31,242,31,140,31,140,31,140,30,140,29,140,28,158,31,116,31,116,30,64,31,55,31,152,31,90,31,210,31,189,31,72,31,216,31,50,31,145,31,145,30,100,31,69,31,69,30,69,29,14,31,14,30,41,31,41,30,134,31,124,31,43,31,54,31,60,31,166,31,1,31,36,31,3,31,103,31,103,30,67,31,43,31,198,31,107,31,107,30,179,31,172,31,172,30,182,31,92,31,76,31,61,31,94,31,88,31,212,31);

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
