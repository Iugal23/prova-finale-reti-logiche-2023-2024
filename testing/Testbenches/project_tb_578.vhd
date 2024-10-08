-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_578 is
end project_tb_578;

architecture project_tb_arch_578 of project_tb_578 is
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

constant SCENARIO_LENGTH : integer := 668;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,236,0,0,0,80,0,231,0,5,0,122,0,116,0,117,0,174,0,238,0,152,0,59,0,157,0,121,0,161,0,4,0,119,0,43,0,120,0,82,0,0,0,37,0,4,0,15,0,25,0,0,0,0,0,210,0,0,0,212,0,164,0,226,0,0,0,127,0,224,0,250,0,128,0,163,0,237,0,104,0,33,0,79,0,10,0,209,0,178,0,116,0,54,0,228,0,230,0,247,0,162,0,39,0,91,0,228,0,35,0,0,0,114,0,98,0,223,0,35,0,0,0,217,0,190,0,191,0,0,0,102,0,0,0,0,0,44,0,114,0,0,0,53,0,0,0,96,0,164,0,252,0,52,0,205,0,124,0,0,0,180,0,42,0,150,0,179,0,134,0,212,0,230,0,0,0,0,0,221,0,144,0,0,0,250,0,205,0,222,0,226,0,0,0,244,0,91,0,77,0,174,0,173,0,0,0,88,0,238,0,92,0,241,0,66,0,218,0,125,0,188,0,157,0,11,0,127,0,159,0,151,0,15,0,60,0,200,0,0,0,106,0,119,0,231,0,98,0,81,0,236,0,184,0,66,0,37,0,0,0,50,0,22,0,86,0,2,0,205,0,7,0,94,0,144,0,82,0,187,0,181,0,0,0,214,0,235,0,195,0,45,0,86,0,0,0,63,0,67,0,243,0,0,0,215,0,119,0,214,0,0,0,253,0,124,0,0,0,79,0,0,0,90,0,248,0,223,0,212,0,175,0,163,0,0,0,208,0,106,0,208,0,131,0,196,0,220,0,103,0,121,0,0,0,116,0,64,0,155,0,0,0,67,0,39,0,0,0,189,0,23,0,108,0,36,0,97,0,41,0,168,0,152,0,62,0,226,0,100,0,49,0,129,0,167,0,0,0,28,0,230,0,226,0,13,0,123,0,32,0,13,0,130,0,75,0,208,0,0,0,84,0,218,0,0,0,0,0,0,0,131,0,199,0,61,0,220,0,184,0,0,0,0,0,238,0,182,0,0,0,146,0,35,0,201,0,132,0,213,0,213,0,119,0,56,0,0,0,48,0,133,0,87,0,138,0,186,0,0,0,206,0,130,0,55,0,69,0,8,0,113,0,249,0,0,0,227,0,88,0,78,0,36,0,0,0,6,0,0,0,65,0,54,0,118,0,7,0,176,0,208,0,60,0,0,0,125,0,18,0,0,0,0,0,70,0,58,0,104,0,9,0,137,0,62,0,240,0,118,0,176,0,224,0,170,0,4,0,95,0,211,0,0,0,135,0,211,0,102,0,148,0,147,0,9,0,20,0,7,0,229,0,21,0,248,0,221,0,111,0,0,0,186,0,0,0,6,0,255,0,151,0,196,0,206,0,120,0,188,0,74,0,58,0,163,0,0,0,96,0,40,0,0,0,58,0,71,0,0,0,54,0,0,0,129,0,0,0,0,0,0,0,53,0,8,0,114,0,0,0,0,0,192,0,209,0,159,0,138,0,153,0,26,0,178,0,100,0,0,0,18,0,88,0,132,0,0,0,149,0,141,0,0,0,206,0,103,0,79,0,0,0,0,0,235,0,220,0,37,0,205,0,243,0,0,0,201,0,0,0,105,0,236,0,19,0,0,0,221,0,42,0,0,0,213,0,0,0,199,0,190,0,180,0,184,0,16,0,62,0,69,0,96,0,205,0,73,0,0,0,247,0,44,0,175,0,0,0,235,0,230,0,99,0,231,0,0,0,147,0,224,0,0,0,91,0,0,0,86,0,0,0,213,0,83,0,100,0,125,0,175,0,22,0,0,0,106,0,33,0,202,0,0,0,148,0,0,0,0,0,22,0,238,0,32,0,170,0,194,0,156,0,56,0,89,0,236,0,166,0,9,0,126,0,106,0,0,0,166,0,0,0,0,0,125,0,0,0,232,0,35,0,176,0,0,0,125,0,45,0,173,0,0,0,81,0,0,0,126,0,180,0,177,0,0,0,0,0,98,0,213,0,0,0,0,0,92,0,57,0,193,0,2,0,0,0,95,0,241,0,39,0,92,0,188,0,0,0,3,0,0,0,91,0,202,0,18,0,61,0,124,0,0,0,17,0,157,0,174,0,238,0,31,0,248,0,94,0,158,0,0,0,89,0,152,0,111,0,0,0,0,0,135,0,22,0,87,0,254,0,203,0,52,0,218,0,254,0,138,0,83,0,211,0,119,0,239,0,41,0,195,0,54,0,182,0,174,0,221,0,0,0,17,0,12,0,70,0,248,0,54,0,88,0,108,0,0,0,213,0,137,0,0,0,114,0,205,0,22,0,240,0,226,0,252,0,218,0,1,0,54,0,0,0,247,0,146,0,113,0,136,0,145,0,24,0,169,0,18,0,0,0,60,0,95,0,236,0,30,0,243,0,23,0,59,0,113,0,152,0,14,0,218,0,12,0,36,0,0,0,96,0,23,0,86,0,77,0,0,0,177,0,0,0,97,0,0,0,45,0,124,0,146,0,177,0,91,0,151,0,0,0,9,0,122,0,202,0,49,0,217,0,175,0,118,0,0,0,37,0,72,0,237,0,8,0,44,0,170,0,28,0,27,0,135,0,161,0,59,0,0,0,95,0,251,0,190,0,252,0,17,0,0,0,0,0,207,0,134,0,236,0,0,0,223,0,199,0,0,0,228,0,0,0,83,0,214,0,34,0,168,0,177,0,142,0,186,0,57,0,227,0,0,0,226,0,112,0,206,0,214,0,0,0,171,0,0,0,9,0,0,0,0,0,163,0,124,0,142,0,193,0,239,0,190,0,76,0,43,0,165,0,85,0,132,0,133,0,31,0,118,0,0,0,52,0,181,0,202,0,136,0,2,0,157,0,239,0,123,0,228,0,138,0,0,0,0,0,0,0,156,0,217,0,57,0,0,0,239,0,219,0,178,0,78,0,56,0,223,0,119,0,145,0,170,0,158,0,26,0,129,0,48,0,69,0,0,0,248,0,0,0,138,0,0,0,29,0,93,0,0,0,245,0);
signal scenario_full  : scenario_type := (0,0,236,31,236,30,80,31,231,31,5,31,122,31,116,31,117,31,174,31,238,31,152,31,59,31,157,31,121,31,161,31,4,31,119,31,43,31,120,31,82,31,82,30,37,31,4,31,15,31,25,31,25,30,25,29,210,31,210,30,212,31,164,31,226,31,226,30,127,31,224,31,250,31,128,31,163,31,237,31,104,31,33,31,79,31,10,31,209,31,178,31,116,31,54,31,228,31,230,31,247,31,162,31,39,31,91,31,228,31,35,31,35,30,114,31,98,31,223,31,35,31,35,30,217,31,190,31,191,31,191,30,102,31,102,30,102,29,44,31,114,31,114,30,53,31,53,30,96,31,164,31,252,31,52,31,205,31,124,31,124,30,180,31,42,31,150,31,179,31,134,31,212,31,230,31,230,30,230,29,221,31,144,31,144,30,250,31,205,31,222,31,226,31,226,30,244,31,91,31,77,31,174,31,173,31,173,30,88,31,238,31,92,31,241,31,66,31,218,31,125,31,188,31,157,31,11,31,127,31,159,31,151,31,15,31,60,31,200,31,200,30,106,31,119,31,231,31,98,31,81,31,236,31,184,31,66,31,37,31,37,30,50,31,22,31,86,31,2,31,205,31,7,31,94,31,144,31,82,31,187,31,181,31,181,30,214,31,235,31,195,31,45,31,86,31,86,30,63,31,67,31,243,31,243,30,215,31,119,31,214,31,214,30,253,31,124,31,124,30,79,31,79,30,90,31,248,31,223,31,212,31,175,31,163,31,163,30,208,31,106,31,208,31,131,31,196,31,220,31,103,31,121,31,121,30,116,31,64,31,155,31,155,30,67,31,39,31,39,30,189,31,23,31,108,31,36,31,97,31,41,31,168,31,152,31,62,31,226,31,100,31,49,31,129,31,167,31,167,30,28,31,230,31,226,31,13,31,123,31,32,31,13,31,130,31,75,31,208,31,208,30,84,31,218,31,218,30,218,29,218,28,131,31,199,31,61,31,220,31,184,31,184,30,184,29,238,31,182,31,182,30,146,31,35,31,201,31,132,31,213,31,213,31,119,31,56,31,56,30,48,31,133,31,87,31,138,31,186,31,186,30,206,31,130,31,55,31,69,31,8,31,113,31,249,31,249,30,227,31,88,31,78,31,36,31,36,30,6,31,6,30,65,31,54,31,118,31,7,31,176,31,208,31,60,31,60,30,125,31,18,31,18,30,18,29,70,31,58,31,104,31,9,31,137,31,62,31,240,31,118,31,176,31,224,31,170,31,4,31,95,31,211,31,211,30,135,31,211,31,102,31,148,31,147,31,9,31,20,31,7,31,229,31,21,31,248,31,221,31,111,31,111,30,186,31,186,30,6,31,255,31,151,31,196,31,206,31,120,31,188,31,74,31,58,31,163,31,163,30,96,31,40,31,40,30,58,31,71,31,71,30,54,31,54,30,129,31,129,30,129,29,129,28,53,31,8,31,114,31,114,30,114,29,192,31,209,31,159,31,138,31,153,31,26,31,178,31,100,31,100,30,18,31,88,31,132,31,132,30,149,31,141,31,141,30,206,31,103,31,79,31,79,30,79,29,235,31,220,31,37,31,205,31,243,31,243,30,201,31,201,30,105,31,236,31,19,31,19,30,221,31,42,31,42,30,213,31,213,30,199,31,190,31,180,31,184,31,16,31,62,31,69,31,96,31,205,31,73,31,73,30,247,31,44,31,175,31,175,30,235,31,230,31,99,31,231,31,231,30,147,31,224,31,224,30,91,31,91,30,86,31,86,30,213,31,83,31,100,31,125,31,175,31,22,31,22,30,106,31,33,31,202,31,202,30,148,31,148,30,148,29,22,31,238,31,32,31,170,31,194,31,156,31,56,31,89,31,236,31,166,31,9,31,126,31,106,31,106,30,166,31,166,30,166,29,125,31,125,30,232,31,35,31,176,31,176,30,125,31,45,31,173,31,173,30,81,31,81,30,126,31,180,31,177,31,177,30,177,29,98,31,213,31,213,30,213,29,92,31,57,31,193,31,2,31,2,30,95,31,241,31,39,31,92,31,188,31,188,30,3,31,3,30,91,31,202,31,18,31,61,31,124,31,124,30,17,31,157,31,174,31,238,31,31,31,248,31,94,31,158,31,158,30,89,31,152,31,111,31,111,30,111,29,135,31,22,31,87,31,254,31,203,31,52,31,218,31,254,31,138,31,83,31,211,31,119,31,239,31,41,31,195,31,54,31,182,31,174,31,221,31,221,30,17,31,12,31,70,31,248,31,54,31,88,31,108,31,108,30,213,31,137,31,137,30,114,31,205,31,22,31,240,31,226,31,252,31,218,31,1,31,54,31,54,30,247,31,146,31,113,31,136,31,145,31,24,31,169,31,18,31,18,30,60,31,95,31,236,31,30,31,243,31,23,31,59,31,113,31,152,31,14,31,218,31,12,31,36,31,36,30,96,31,23,31,86,31,77,31,77,30,177,31,177,30,97,31,97,30,45,31,124,31,146,31,177,31,91,31,151,31,151,30,9,31,122,31,202,31,49,31,217,31,175,31,118,31,118,30,37,31,72,31,237,31,8,31,44,31,170,31,28,31,27,31,135,31,161,31,59,31,59,30,95,31,251,31,190,31,252,31,17,31,17,30,17,29,207,31,134,31,236,31,236,30,223,31,199,31,199,30,228,31,228,30,83,31,214,31,34,31,168,31,177,31,142,31,186,31,57,31,227,31,227,30,226,31,112,31,206,31,214,31,214,30,171,31,171,30,9,31,9,30,9,29,163,31,124,31,142,31,193,31,239,31,190,31,76,31,43,31,165,31,85,31,132,31,133,31,31,31,118,31,118,30,52,31,181,31,202,31,136,31,2,31,157,31,239,31,123,31,228,31,138,31,138,30,138,29,138,28,156,31,217,31,57,31,57,30,239,31,219,31,178,31,78,31,56,31,223,31,119,31,145,31,170,31,158,31,26,31,129,31,48,31,69,31,69,30,248,31,248,30,138,31,138,30,29,31,93,31,93,30,245,31);

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
