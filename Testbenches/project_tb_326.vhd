-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_326 is
end project_tb_326;

architecture project_tb_arch_326 of project_tb_326 is
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

constant SCENARIO_LENGTH : integer := 600;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (52,0,0,0,133,0,0,0,97,0,0,0,0,0,94,0,23,0,28,0,155,0,84,0,104,0,99,0,115,0,166,0,115,0,0,0,64,0,0,0,209,0,46,0,68,0,89,0,0,0,229,0,44,0,34,0,135,0,250,0,54,0,73,0,224,0,217,0,61,0,0,0,147,0,138,0,0,0,0,0,107,0,144,0,64,0,0,0,99,0,39,0,177,0,39,0,3,0,109,0,81,0,185,0,204,0,104,0,39,0,215,0,158,0,0,0,59,0,0,0,148,0,155,0,52,0,229,0,0,0,0,0,169,0,102,0,134,0,249,0,242,0,170,0,175,0,0,0,0,0,27,0,76,0,0,0,47,0,227,0,251,0,81,0,76,0,145,0,38,0,16,0,0,0,155,0,205,0,224,0,110,0,229,0,224,0,0,0,133,0,0,0,147,0,198,0,69,0,0,0,18,0,0,0,28,0,0,0,77,0,17,0,61,0,148,0,150,0,59,0,0,0,109,0,235,0,178,0,170,0,85,0,0,0,81,0,0,0,133,0,137,0,76,0,9,0,0,0,97,0,213,0,94,0,228,0,227,0,117,0,113,0,230,0,129,0,0,0,0,0,163,0,211,0,121,0,38,0,81,0,83,0,203,0,77,0,0,0,121,0,0,0,78,0,109,0,0,0,11,0,0,0,73,0,0,0,125,0,0,0,152,0,235,0,89,0,104,0,189,0,255,0,38,0,50,0,186,0,63,0,4,0,0,0,133,0,140,0,21,0,138,0,181,0,252,0,118,0,142,0,198,0,0,0,77,0,210,0,77,0,144,0,209,0,114,0,45,0,0,0,55,0,184,0,201,0,216,0,241,0,186,0,0,0,239,0,0,0,206,0,173,0,0,0,110,0,13,0,0,0,189,0,174,0,160,0,0,0,0,0,205,0,100,0,94,0,5,0,194,0,136,0,0,0,8,0,3,0,128,0,121,0,191,0,127,0,0,0,224,0,0,0,36,0,0,0,201,0,108,0,0,0,0,0,195,0,79,0,130,0,231,0,166,0,220,0,100,0,63,0,140,0,0,0,104,0,0,0,65,0,154,0,6,0,0,0,15,0,195,0,0,0,120,0,0,0,8,0,173,0,44,0,0,0,181,0,0,0,0,0,30,0,0,0,74,0,190,0,249,0,186,0,30,0,138,0,38,0,0,0,119,0,36,0,164,0,212,0,69,0,0,0,131,0,0,0,109,0,0,0,0,0,0,0,0,0,0,0,129,0,184,0,1,0,188,0,124,0,130,0,245,0,253,0,31,0,0,0,213,0,34,0,108,0,84,0,183,0,117,0,0,0,163,0,146,0,163,0,146,0,183,0,143,0,72,0,233,0,79,0,133,0,140,0,41,0,101,0,0,0,82,0,239,0,50,0,140,0,113,0,0,0,66,0,219,0,0,0,21,0,78,0,47,0,49,0,176,0,0,0,25,0,145,0,96,0,129,0,234,0,248,0,162,0,88,0,232,0,239,0,129,0,80,0,0,0,3,0,50,0,186,0,0,0,51,0,193,0,225,0,0,0,47,0,166,0,16,0,195,0,190,0,88,0,0,0,162,0,0,0,153,0,4,0,98,0,232,0,192,0,127,0,228,0,133,0,112,0,8,0,108,0,0,0,0,0,135,0,112,0,135,0,0,0,210,0,105,0,0,0,169,0,0,0,0,0,0,0,166,0,0,0,87,0,0,0,115,0,235,0,230,0,131,0,0,0,162,0,207,0,0,0,170,0,0,0,122,0,55,0,156,0,60,0,36,0,192,0,87,0,30,0,5,0,151,0,21,0,241,0,49,0,246,0,248,0,21,0,0,0,167,0,19,0,121,0,187,0,113,0,169,0,57,0,181,0,111,0,20,0,134,0,234,0,132,0,216,0,0,0,0,0,120,0,136,0,0,0,72,0,157,0,251,0,4,0,158,0,0,0,242,0,0,0,200,0,247,0,0,0,16,0,14,0,0,0,195,0,150,0,24,0,183,0,68,0,220,0,3,0,13,0,53,0,51,0,242,0,175,0,240,0,182,0,68,0,0,0,185,0,0,0,130,0,217,0,0,0,0,0,0,0,100,0,164,0,0,0,87,0,52,0,0,0,109,0,11,0,227,0,66,0,58,0,140,0,0,0,90,0,111,0,0,0,167,0,0,0,94,0,62,0,203,0,0,0,187,0,35,0,21,0,225,0,63,0,163,0,65,0,0,0,39,0,224,0,239,0,158,0,232,0,191,0,233,0,18,0,0,0,58,0,114,0,39,0,158,0,106,0,0,0,255,0,135,0,0,0,178,0,83,0,122,0,0,0,0,0,117,0,127,0,95,0,10,0,44,0,22,0,0,0,171,0,203,0,20,0,0,0,114,0,202,0,4,0,9,0,8,0,0,0,65,0,151,0,246,0,37,0,0,0,47,0,142,0,144,0,207,0,0,0,7,0,185,0,195,0,0,0,212,0,87,0,238,0,0,0,218,0,122,0,56,0,0,0,80,0,63,0,176,0,14,0,162,0,127,0,192,0,237,0,133,0,215,0,249,0,47,0,69,0,88,0,5,0,212,0,0,0,45,0,172,0,129,0,90,0,42,0,0,0,127,0,57,0,242,0,196,0,238,0,123,0,0,0,88,0,118,0,199,0,0,0,126,0,46,0,48,0,182,0,58,0,252,0,78,0,0,0);
signal scenario_full  : scenario_type := (52,31,52,30,133,31,133,30,97,31,97,30,97,29,94,31,23,31,28,31,155,31,84,31,104,31,99,31,115,31,166,31,115,31,115,30,64,31,64,30,209,31,46,31,68,31,89,31,89,30,229,31,44,31,34,31,135,31,250,31,54,31,73,31,224,31,217,31,61,31,61,30,147,31,138,31,138,30,138,29,107,31,144,31,64,31,64,30,99,31,39,31,177,31,39,31,3,31,109,31,81,31,185,31,204,31,104,31,39,31,215,31,158,31,158,30,59,31,59,30,148,31,155,31,52,31,229,31,229,30,229,29,169,31,102,31,134,31,249,31,242,31,170,31,175,31,175,30,175,29,27,31,76,31,76,30,47,31,227,31,251,31,81,31,76,31,145,31,38,31,16,31,16,30,155,31,205,31,224,31,110,31,229,31,224,31,224,30,133,31,133,30,147,31,198,31,69,31,69,30,18,31,18,30,28,31,28,30,77,31,17,31,61,31,148,31,150,31,59,31,59,30,109,31,235,31,178,31,170,31,85,31,85,30,81,31,81,30,133,31,137,31,76,31,9,31,9,30,97,31,213,31,94,31,228,31,227,31,117,31,113,31,230,31,129,31,129,30,129,29,163,31,211,31,121,31,38,31,81,31,83,31,203,31,77,31,77,30,121,31,121,30,78,31,109,31,109,30,11,31,11,30,73,31,73,30,125,31,125,30,152,31,235,31,89,31,104,31,189,31,255,31,38,31,50,31,186,31,63,31,4,31,4,30,133,31,140,31,21,31,138,31,181,31,252,31,118,31,142,31,198,31,198,30,77,31,210,31,77,31,144,31,209,31,114,31,45,31,45,30,55,31,184,31,201,31,216,31,241,31,186,31,186,30,239,31,239,30,206,31,173,31,173,30,110,31,13,31,13,30,189,31,174,31,160,31,160,30,160,29,205,31,100,31,94,31,5,31,194,31,136,31,136,30,8,31,3,31,128,31,121,31,191,31,127,31,127,30,224,31,224,30,36,31,36,30,201,31,108,31,108,30,108,29,195,31,79,31,130,31,231,31,166,31,220,31,100,31,63,31,140,31,140,30,104,31,104,30,65,31,154,31,6,31,6,30,15,31,195,31,195,30,120,31,120,30,8,31,173,31,44,31,44,30,181,31,181,30,181,29,30,31,30,30,74,31,190,31,249,31,186,31,30,31,138,31,38,31,38,30,119,31,36,31,164,31,212,31,69,31,69,30,131,31,131,30,109,31,109,30,109,29,109,28,109,27,109,26,129,31,184,31,1,31,188,31,124,31,130,31,245,31,253,31,31,31,31,30,213,31,34,31,108,31,84,31,183,31,117,31,117,30,163,31,146,31,163,31,146,31,183,31,143,31,72,31,233,31,79,31,133,31,140,31,41,31,101,31,101,30,82,31,239,31,50,31,140,31,113,31,113,30,66,31,219,31,219,30,21,31,78,31,47,31,49,31,176,31,176,30,25,31,145,31,96,31,129,31,234,31,248,31,162,31,88,31,232,31,239,31,129,31,80,31,80,30,3,31,50,31,186,31,186,30,51,31,193,31,225,31,225,30,47,31,166,31,16,31,195,31,190,31,88,31,88,30,162,31,162,30,153,31,4,31,98,31,232,31,192,31,127,31,228,31,133,31,112,31,8,31,108,31,108,30,108,29,135,31,112,31,135,31,135,30,210,31,105,31,105,30,169,31,169,30,169,29,169,28,166,31,166,30,87,31,87,30,115,31,235,31,230,31,131,31,131,30,162,31,207,31,207,30,170,31,170,30,122,31,55,31,156,31,60,31,36,31,192,31,87,31,30,31,5,31,151,31,21,31,241,31,49,31,246,31,248,31,21,31,21,30,167,31,19,31,121,31,187,31,113,31,169,31,57,31,181,31,111,31,20,31,134,31,234,31,132,31,216,31,216,30,216,29,120,31,136,31,136,30,72,31,157,31,251,31,4,31,158,31,158,30,242,31,242,30,200,31,247,31,247,30,16,31,14,31,14,30,195,31,150,31,24,31,183,31,68,31,220,31,3,31,13,31,53,31,51,31,242,31,175,31,240,31,182,31,68,31,68,30,185,31,185,30,130,31,217,31,217,30,217,29,217,28,100,31,164,31,164,30,87,31,52,31,52,30,109,31,11,31,227,31,66,31,58,31,140,31,140,30,90,31,111,31,111,30,167,31,167,30,94,31,62,31,203,31,203,30,187,31,35,31,21,31,225,31,63,31,163,31,65,31,65,30,39,31,224,31,239,31,158,31,232,31,191,31,233,31,18,31,18,30,58,31,114,31,39,31,158,31,106,31,106,30,255,31,135,31,135,30,178,31,83,31,122,31,122,30,122,29,117,31,127,31,95,31,10,31,44,31,22,31,22,30,171,31,203,31,20,31,20,30,114,31,202,31,4,31,9,31,8,31,8,30,65,31,151,31,246,31,37,31,37,30,47,31,142,31,144,31,207,31,207,30,7,31,185,31,195,31,195,30,212,31,87,31,238,31,238,30,218,31,122,31,56,31,56,30,80,31,63,31,176,31,14,31,162,31,127,31,192,31,237,31,133,31,215,31,249,31,47,31,69,31,88,31,5,31,212,31,212,30,45,31,172,31,129,31,90,31,42,31,42,30,127,31,57,31,242,31,196,31,238,31,123,31,123,30,88,31,118,31,199,31,199,30,126,31,46,31,48,31,182,31,58,31,252,31,78,31,78,30);

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
