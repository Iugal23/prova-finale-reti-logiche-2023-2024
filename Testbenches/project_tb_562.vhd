-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_562 is
end project_tb_562;

architecture project_tb_arch_562 of project_tb_562 is
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

constant SCENARIO_LENGTH : integer := 558;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (43,0,224,0,140,0,69,0,0,0,184,0,187,0,92,0,218,0,0,0,238,0,0,0,0,0,92,0,223,0,52,0,148,0,246,0,90,0,0,0,209,0,175,0,73,0,6,0,120,0,65,0,52,0,137,0,158,0,132,0,12,0,0,0,164,0,87,0,51,0,135,0,161,0,228,0,195,0,25,0,192,0,226,0,45,0,175,0,152,0,136,0,6,0,108,0,0,0,253,0,0,0,48,0,57,0,101,0,0,0,59,0,218,0,0,0,0,0,145,0,136,0,147,0,161,0,32,0,130,0,0,0,26,0,173,0,164,0,243,0,0,0,0,0,62,0,146,0,110,0,143,0,52,0,173,0,71,0,79,0,42,0,232,0,52,0,118,0,88,0,11,0,0,0,0,0,243,0,123,0,35,0,16,0,157,0,173,0,201,0,201,0,39,0,24,0,86,0,0,0,135,0,233,0,0,0,247,0,158,0,76,0,196,0,51,0,0,0,99,0,12,0,97,0,110,0,18,0,253,0,172,0,49,0,0,0,92,0,47,0,180,0,135,0,206,0,150,0,0,0,0,0,175,0,213,0,178,0,229,0,146,0,198,0,0,0,248,0,0,0,126,0,0,0,37,0,0,0,188,0,57,0,21,0,135,0,165,0,223,0,113,0,167,0,77,0,129,0,136,0,70,0,174,0,223,0,164,0,230,0,84,0,51,0,0,0,248,0,122,0,145,0,76,0,0,0,221,0,0,0,36,0,60,0,0,0,219,0,196,0,94,0,0,0,218,0,0,0,0,0,73,0,0,0,0,0,227,0,150,0,226,0,26,0,203,0,0,0,234,0,99,0,139,0,201,0,0,0,58,0,11,0,174,0,147,0,248,0,151,0,208,0,0,0,225,0,0,0,38,0,216,0,137,0,30,0,28,0,255,0,214,0,191,0,37,0,0,0,114,0,59,0,215,0,54,0,50,0,226,0,0,0,180,0,152,0,106,0,23,0,203,0,0,0,0,0,0,0,215,0,170,0,137,0,215,0,0,0,201,0,171,0,39,0,48,0,113,0,8,0,21,0,0,0,139,0,120,0,142,0,0,0,33,0,87,0,65,0,211,0,63,0,248,0,0,0,18,0,38,0,0,0,109,0,130,0,26,0,68,0,97,0,97,0,60,0,0,0,43,0,189,0,36,0,8,0,81,0,236,0,154,0,108,0,10,0,0,0,229,0,127,0,52,0,0,0,57,0,249,0,53,0,7,0,26,0,16,0,53,0,53,0,13,0,0,0,8,0,117,0,182,0,0,0,100,0,155,0,131,0,215,0,51,0,207,0,25,0,140,0,106,0,0,0,144,0,0,0,45,0,78,0,250,0,28,0,157,0,156,0,213,0,175,0,147,0,104,0,113,0,115,0,62,0,0,0,10,0,0,0,181,0,105,0,180,0,175,0,0,0,0,0,96,0,77,0,0,0,234,0,136,0,4,0,180,0,134,0,106,0,67,0,228,0,20,0,186,0,0,0,33,0,247,0,122,0,243,0,28,0,27,0,97,0,37,0,0,0,131,0,173,0,126,0,26,0,117,0,165,0,132,0,0,0,118,0,121,0,111,0,0,0,52,0,203,0,0,0,152,0,137,0,0,0,0,0,160,0,44,0,222,0,253,0,251,0,210,0,62,0,140,0,158,0,79,0,211,0,0,0,109,0,153,0,166,0,81,0,178,0,0,0,21,0,105,0,115,0,234,0,216,0,207,0,0,0,27,0,231,0,242,0,0,0,234,0,29,0,21,0,58,0,125,0,162,0,185,0,189,0,149,0,94,0,54,0,48,0,23,0,160,0,34,0,135,0,187,0,189,0,12,0,116,0,15,0,53,0,0,0,50,0,0,0,233,0,119,0,227,0,3,0,217,0,0,0,249,0,0,0,136,0,106,0,0,0,3,0,113,0,0,0,249,0,106,0,9,0,109,0,31,0,78,0,0,0,82,0,181,0,115,0,245,0,244,0,189,0,208,0,252,0,240,0,0,0,137,0,227,0,32,0,0,0,193,0,0,0,229,0,0,0,204,0,62,0,203,0,208,0,0,0,152,0,84,0,224,0,0,0,200,0,185,0,109,0,204,0,106,0,72,0,6,0,244,0,189,0,65,0,137,0,220,0,55,0,0,0,131,0,0,0,206,0,183,0,0,0,150,0,35,0,127,0,142,0,0,0,153,0,0,0,216,0,0,0,31,0,11,0,48,0,47,0,129,0,0,0,0,0,0,0,0,0,125,0,223,0,172,0,234,0,224,0,0,0,237,0,141,0,246,0,239,0,113,0,128,0,233,0,0,0,160,0,21,0,241,0,26,0,143,0,217,0,238,0,159,0,100,0,32,0,139,0,151,0,190,0,221,0,128,0,241,0,42,0,214,0,85,0,70,0,96,0,212,0,0,0,224,0,217,0,243,0,177,0,226,0,174,0,44,0,92,0,0,0,103,0,132,0,19,0,215,0,3,0,249,0,0,0,253,0,180,0,130,0);
signal scenario_full  : scenario_type := (43,31,224,31,140,31,69,31,69,30,184,31,187,31,92,31,218,31,218,30,238,31,238,30,238,29,92,31,223,31,52,31,148,31,246,31,90,31,90,30,209,31,175,31,73,31,6,31,120,31,65,31,52,31,137,31,158,31,132,31,12,31,12,30,164,31,87,31,51,31,135,31,161,31,228,31,195,31,25,31,192,31,226,31,45,31,175,31,152,31,136,31,6,31,108,31,108,30,253,31,253,30,48,31,57,31,101,31,101,30,59,31,218,31,218,30,218,29,145,31,136,31,147,31,161,31,32,31,130,31,130,30,26,31,173,31,164,31,243,31,243,30,243,29,62,31,146,31,110,31,143,31,52,31,173,31,71,31,79,31,42,31,232,31,52,31,118,31,88,31,11,31,11,30,11,29,243,31,123,31,35,31,16,31,157,31,173,31,201,31,201,31,39,31,24,31,86,31,86,30,135,31,233,31,233,30,247,31,158,31,76,31,196,31,51,31,51,30,99,31,12,31,97,31,110,31,18,31,253,31,172,31,49,31,49,30,92,31,47,31,180,31,135,31,206,31,150,31,150,30,150,29,175,31,213,31,178,31,229,31,146,31,198,31,198,30,248,31,248,30,126,31,126,30,37,31,37,30,188,31,57,31,21,31,135,31,165,31,223,31,113,31,167,31,77,31,129,31,136,31,70,31,174,31,223,31,164,31,230,31,84,31,51,31,51,30,248,31,122,31,145,31,76,31,76,30,221,31,221,30,36,31,60,31,60,30,219,31,196,31,94,31,94,30,218,31,218,30,218,29,73,31,73,30,73,29,227,31,150,31,226,31,26,31,203,31,203,30,234,31,99,31,139,31,201,31,201,30,58,31,11,31,174,31,147,31,248,31,151,31,208,31,208,30,225,31,225,30,38,31,216,31,137,31,30,31,28,31,255,31,214,31,191,31,37,31,37,30,114,31,59,31,215,31,54,31,50,31,226,31,226,30,180,31,152,31,106,31,23,31,203,31,203,30,203,29,203,28,215,31,170,31,137,31,215,31,215,30,201,31,171,31,39,31,48,31,113,31,8,31,21,31,21,30,139,31,120,31,142,31,142,30,33,31,87,31,65,31,211,31,63,31,248,31,248,30,18,31,38,31,38,30,109,31,130,31,26,31,68,31,97,31,97,31,60,31,60,30,43,31,189,31,36,31,8,31,81,31,236,31,154,31,108,31,10,31,10,30,229,31,127,31,52,31,52,30,57,31,249,31,53,31,7,31,26,31,16,31,53,31,53,31,13,31,13,30,8,31,117,31,182,31,182,30,100,31,155,31,131,31,215,31,51,31,207,31,25,31,140,31,106,31,106,30,144,31,144,30,45,31,78,31,250,31,28,31,157,31,156,31,213,31,175,31,147,31,104,31,113,31,115,31,62,31,62,30,10,31,10,30,181,31,105,31,180,31,175,31,175,30,175,29,96,31,77,31,77,30,234,31,136,31,4,31,180,31,134,31,106,31,67,31,228,31,20,31,186,31,186,30,33,31,247,31,122,31,243,31,28,31,27,31,97,31,37,31,37,30,131,31,173,31,126,31,26,31,117,31,165,31,132,31,132,30,118,31,121,31,111,31,111,30,52,31,203,31,203,30,152,31,137,31,137,30,137,29,160,31,44,31,222,31,253,31,251,31,210,31,62,31,140,31,158,31,79,31,211,31,211,30,109,31,153,31,166,31,81,31,178,31,178,30,21,31,105,31,115,31,234,31,216,31,207,31,207,30,27,31,231,31,242,31,242,30,234,31,29,31,21,31,58,31,125,31,162,31,185,31,189,31,149,31,94,31,54,31,48,31,23,31,160,31,34,31,135,31,187,31,189,31,12,31,116,31,15,31,53,31,53,30,50,31,50,30,233,31,119,31,227,31,3,31,217,31,217,30,249,31,249,30,136,31,106,31,106,30,3,31,113,31,113,30,249,31,106,31,9,31,109,31,31,31,78,31,78,30,82,31,181,31,115,31,245,31,244,31,189,31,208,31,252,31,240,31,240,30,137,31,227,31,32,31,32,30,193,31,193,30,229,31,229,30,204,31,62,31,203,31,208,31,208,30,152,31,84,31,224,31,224,30,200,31,185,31,109,31,204,31,106,31,72,31,6,31,244,31,189,31,65,31,137,31,220,31,55,31,55,30,131,31,131,30,206,31,183,31,183,30,150,31,35,31,127,31,142,31,142,30,153,31,153,30,216,31,216,30,31,31,11,31,48,31,47,31,129,31,129,30,129,29,129,28,129,27,125,31,223,31,172,31,234,31,224,31,224,30,237,31,141,31,246,31,239,31,113,31,128,31,233,31,233,30,160,31,21,31,241,31,26,31,143,31,217,31,238,31,159,31,100,31,32,31,139,31,151,31,190,31,221,31,128,31,241,31,42,31,214,31,85,31,70,31,96,31,212,31,212,30,224,31,217,31,243,31,177,31,226,31,174,31,44,31,92,31,92,30,103,31,132,31,19,31,215,31,3,31,249,31,249,30,253,31,180,31,130,31);

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
