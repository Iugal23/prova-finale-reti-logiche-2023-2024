-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_855 is
end project_tb_855;

architecture project_tb_arch_855 of project_tb_855 is
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

constant SCENARIO_LENGTH : integer := 390;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (115,0,0,0,203,0,94,0,54,0,0,0,193,0,0,0,59,0,236,0,94,0,26,0,126,0,246,0,70,0,113,0,33,0,201,0,102,0,89,0,209,0,0,0,79,0,213,0,98,0,30,0,201,0,193,0,0,0,5,0,77,0,161,0,185,0,100,0,0,0,253,0,51,0,58,0,134,0,0,0,57,0,15,0,0,0,249,0,17,0,68,0,150,0,77,0,0,0,201,0,57,0,6,0,0,0,70,0,0,0,25,0,180,0,117,0,0,0,203,0,180,0,0,0,199,0,238,0,0,0,171,0,43,0,43,0,19,0,42,0,134,0,249,0,52,0,35,0,12,0,175,0,67,0,21,0,182,0,123,0,0,0,0,0,85,0,0,0,147,0,38,0,179,0,129,0,197,0,0,0,37,0,11,0,202,0,22,0,53,0,52,0,38,0,82,0,210,0,145,0,191,0,148,0,185,0,130,0,115,0,36,0,0,0,251,0,35,0,14,0,131,0,21,0,78,0,0,0,134,0,72,0,169,0,0,0,108,0,0,0,35,0,248,0,101,0,135,0,233,0,58,0,15,0,0,0,192,0,217,0,31,0,175,0,162,0,0,0,0,0,10,0,129,0,3,0,235,0,98,0,15,0,63,0,0,0,153,0,164,0,30,0,0,0,70,0,251,0,0,0,138,0,136,0,25,0,199,0,181,0,0,0,36,0,0,0,149,0,34,0,198,0,85,0,0,0,211,0,0,0,0,0,38,0,177,0,206,0,205,0,84,0,98,0,176,0,0,0,146,0,216,0,105,0,96,0,234,0,27,0,53,0,152,0,4,0,76,0,0,0,206,0,0,0,2,0,249,0,0,0,206,0,232,0,230,0,0,0,77,0,0,0,19,0,0,0,148,0,0,0,166,0,167,0,173,0,191,0,68,0,116,0,0,0,190,0,0,0,0,0,38,0,177,0,162,0,243,0,255,0,191,0,122,0,0,0,22,0,60,0,93,0,225,0,49,0,87,0,138,0,73,0,9,0,73,0,0,0,110,0,108,0,248,0,6,0,60,0,169,0,109,0,0,0,0,0,155,0,0,0,22,0,73,0,6,0,85,0,0,0,162,0,237,0,0,0,75,0,19,0,0,0,55,0,112,0,23,0,116,0,154,0,83,0,240,0,150,0,192,0,244,0,235,0,214,0,171,0,28,0,32,0,213,0,56,0,0,0,211,0,0,0,101,0,5,0,180,0,56,0,224,0,210,0,55,0,143,0,235,0,190,0,153,0,69,0,159,0,97,0,153,0,24,0,30,0,204,0,102,0,125,0,0,0,190,0,238,0,0,0,57,0,87,0,238,0,0,0,106,0,0,0,210,0,202,0,0,0,0,0,60,0,0,0,144,0,211,0,0,0,252,0,163,0,123,0,110,0,110,0,157,0,189,0,151,0,13,0,170,0,237,0,159,0,54,0,214,0,0,0,241,0,52,0,0,0,189,0,0,0,103,0,34,0,0,0,200,0,175,0,110,0,19,0,237,0,5,0,159,0,0,0,7,0,64,0,0,0,223,0,0,0,68,0,147,0,28,0,183,0,134,0,87,0,143,0,74,0,120,0,116,0,210,0,77,0,0,0,0,0,224,0,93,0,39,0,150,0,63,0,0,0,2,0,0,0,162,0,179,0,18,0,23,0,0,0,9,0,38,0,123,0,253,0,254,0,147,0,53,0,0,0,234,0,118,0,57,0,251,0,26,0,0,0,130,0,48,0,0,0);
signal scenario_full  : scenario_type := (115,31,115,30,203,31,94,31,54,31,54,30,193,31,193,30,59,31,236,31,94,31,26,31,126,31,246,31,70,31,113,31,33,31,201,31,102,31,89,31,209,31,209,30,79,31,213,31,98,31,30,31,201,31,193,31,193,30,5,31,77,31,161,31,185,31,100,31,100,30,253,31,51,31,58,31,134,31,134,30,57,31,15,31,15,30,249,31,17,31,68,31,150,31,77,31,77,30,201,31,57,31,6,31,6,30,70,31,70,30,25,31,180,31,117,31,117,30,203,31,180,31,180,30,199,31,238,31,238,30,171,31,43,31,43,31,19,31,42,31,134,31,249,31,52,31,35,31,12,31,175,31,67,31,21,31,182,31,123,31,123,30,123,29,85,31,85,30,147,31,38,31,179,31,129,31,197,31,197,30,37,31,11,31,202,31,22,31,53,31,52,31,38,31,82,31,210,31,145,31,191,31,148,31,185,31,130,31,115,31,36,31,36,30,251,31,35,31,14,31,131,31,21,31,78,31,78,30,134,31,72,31,169,31,169,30,108,31,108,30,35,31,248,31,101,31,135,31,233,31,58,31,15,31,15,30,192,31,217,31,31,31,175,31,162,31,162,30,162,29,10,31,129,31,3,31,235,31,98,31,15,31,63,31,63,30,153,31,164,31,30,31,30,30,70,31,251,31,251,30,138,31,136,31,25,31,199,31,181,31,181,30,36,31,36,30,149,31,34,31,198,31,85,31,85,30,211,31,211,30,211,29,38,31,177,31,206,31,205,31,84,31,98,31,176,31,176,30,146,31,216,31,105,31,96,31,234,31,27,31,53,31,152,31,4,31,76,31,76,30,206,31,206,30,2,31,249,31,249,30,206,31,232,31,230,31,230,30,77,31,77,30,19,31,19,30,148,31,148,30,166,31,167,31,173,31,191,31,68,31,116,31,116,30,190,31,190,30,190,29,38,31,177,31,162,31,243,31,255,31,191,31,122,31,122,30,22,31,60,31,93,31,225,31,49,31,87,31,138,31,73,31,9,31,73,31,73,30,110,31,108,31,248,31,6,31,60,31,169,31,109,31,109,30,109,29,155,31,155,30,22,31,73,31,6,31,85,31,85,30,162,31,237,31,237,30,75,31,19,31,19,30,55,31,112,31,23,31,116,31,154,31,83,31,240,31,150,31,192,31,244,31,235,31,214,31,171,31,28,31,32,31,213,31,56,31,56,30,211,31,211,30,101,31,5,31,180,31,56,31,224,31,210,31,55,31,143,31,235,31,190,31,153,31,69,31,159,31,97,31,153,31,24,31,30,31,204,31,102,31,125,31,125,30,190,31,238,31,238,30,57,31,87,31,238,31,238,30,106,31,106,30,210,31,202,31,202,30,202,29,60,31,60,30,144,31,211,31,211,30,252,31,163,31,123,31,110,31,110,31,157,31,189,31,151,31,13,31,170,31,237,31,159,31,54,31,214,31,214,30,241,31,52,31,52,30,189,31,189,30,103,31,34,31,34,30,200,31,175,31,110,31,19,31,237,31,5,31,159,31,159,30,7,31,64,31,64,30,223,31,223,30,68,31,147,31,28,31,183,31,134,31,87,31,143,31,74,31,120,31,116,31,210,31,77,31,77,30,77,29,224,31,93,31,39,31,150,31,63,31,63,30,2,31,2,30,162,31,179,31,18,31,23,31,23,30,9,31,38,31,123,31,253,31,254,31,147,31,53,31,53,30,234,31,118,31,57,31,251,31,26,31,26,30,130,31,48,31,48,30);

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
