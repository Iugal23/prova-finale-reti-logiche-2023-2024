-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_731 is
end project_tb_731;

architecture project_tb_arch_731 of project_tb_731 is
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

constant SCENARIO_LENGTH : integer := 612;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (116,0,211,0,0,0,182,0,104,0,50,0,0,0,29,0,0,0,28,0,34,0,0,0,222,0,64,0,244,0,13,0,252,0,234,0,0,0,73,0,3,0,155,0,57,0,94,0,20,0,15,0,16,0,252,0,124,0,89,0,255,0,36,0,0,0,92,0,192,0,64,0,0,0,0,0,141,0,130,0,0,0,229,0,223,0,0,0,147,0,153,0,174,0,0,0,246,0,84,0,115,0,107,0,0,0,0,0,233,0,217,0,147,0,0,0,232,0,227,0,226,0,180,0,194,0,51,0,159,0,254,0,0,0,0,0,112,0,204,0,133,0,124,0,32,0,0,0,85,0,63,0,153,0,239,0,0,0,164,0,122,0,255,0,237,0,34,0,154,0,243,0,114,0,43,0,157,0,67,0,218,0,0,0,120,0,154,0,254,0,62,0,0,0,115,0,159,0,104,0,154,0,239,0,13,0,231,0,8,0,0,0,0,0,28,0,214,0,236,0,156,0,73,0,5,0,141,0,242,0,161,0,141,0,0,0,223,0,243,0,64,0,163,0,229,0,0,0,126,0,21,0,59,0,155,0,132,0,163,0,47,0,43,0,18,0,199,0,0,0,180,0,109,0,128,0,151,0,0,0,145,0,132,0,243,0,70,0,0,0,197,0,73,0,0,0,4,0,189,0,234,0,0,0,0,0,0,0,79,0,133,0,34,0,7,0,91,0,135,0,0,0,229,0,0,0,122,0,21,0,170,0,161,0,89,0,0,0,249,0,0,0,0,0,161,0,217,0,192,0,0,0,38,0,166,0,153,0,171,0,10,0,112,0,162,0,54,0,206,0,71,0,150,0,230,0,0,0,170,0,249,0,154,0,164,0,90,0,0,0,36,0,108,0,8,0,180,0,155,0,137,0,138,0,22,0,154,0,188,0,0,0,173,0,0,0,0,0,235,0,152,0,109,0,196,0,156,0,155,0,88,0,137,0,12,0,151,0,81,0,0,0,240,0,58,0,88,0,142,0,253,0,196,0,0,0,0,0,0,0,64,0,144,0,142,0,243,0,0,0,166,0,0,0,197,0,165,0,171,0,100,0,0,0,0,0,246,0,0,0,93,0,74,0,47,0,121,0,172,0,19,0,58,0,81,0,12,0,0,0,59,0,135,0,0,0,0,0,170,0,65,0,213,0,0,0,0,0,72,0,106,0,74,0,230,0,41,0,120,0,0,0,146,0,224,0,123,0,0,0,35,0,184,0,229,0,89,0,172,0,57,0,0,0,199,0,46,0,163,0,108,0,20,0,170,0,25,0,233,0,0,0,85,0,188,0,0,0,250,0,201,0,0,0,240,0,210,0,174,0,176,0,144,0,204,0,32,0,83,0,5,0,71,0,188,0,0,0,79,0,4,0,8,0,131,0,0,0,197,0,98,0,234,0,22,0,98,0,20,0,94,0,69,0,179,0,0,0,141,0,9,0,118,0,64,0,181,0,60,0,32,0,0,0,156,0,0,0,155,0,105,0,224,0,105,0,66,0,249,0,34,0,219,0,0,0,0,0,178,0,0,0,254,0,216,0,27,0,10,0,137,0,208,0,0,0,0,0,0,0,211,0,134,0,195,0,0,0,0,0,73,0,235,0,195,0,161,0,0,0,191,0,177,0,35,0,77,0,59,0,0,0,194,0,203,0,70,0,175,0,16,0,222,0,155,0,52,0,160,0,191,0,180,0,15,0,51,0,253,0,59,0,0,0,66,0,195,0,120,0,37,0,0,0,153,0,0,0,173,0,161,0,129,0,68,0,13,0,198,0,0,0,249,0,113,0,0,0,116,0,34,0,0,0,203,0,148,0,167,0,231,0,57,0,243,0,82,0,11,0,214,0,42,0,193,0,19,0,52,0,76,0,0,0,0,0,0,0,229,0,149,0,145,0,0,0,222,0,208,0,222,0,182,0,65,0,0,0,81,0,39,0,39,0,177,0,143,0,201,0,218,0,0,0,29,0,0,0,48,0,132,0,14,0,185,0,48,0,120,0,170,0,238,0,183,0,199,0,0,0,181,0,214,0,206,0,0,0,117,0,0,0,115,0,71,0,75,0,203,0,0,0,207,0,173,0,0,0,70,0,219,0,86,0,0,0,94,0,56,0,55,0,95,0,250,0,101,0,223,0,24,0,90,0,59,0,115,0,184,0,189,0,119,0,220,0,120,0,143,0,0,0,0,0,0,0,218,0,232,0,208,0,85,0,0,0,135,0,0,0,156,0,151,0,157,0,0,0,0,0,87,0,89,0,14,0,227,0,241,0,0,0,241,0,0,0,103,0,130,0,0,0,185,0,9,0,95,0,177,0,103,0,66,0,159,0,47,0,63,0,45,0,0,0,195,0,139,0,0,0,135,0,8,0,0,0,0,0,222,0,19,0,86,0,229,0,159,0,125,0,108,0,223,0,210,0,45,0,0,0,25,0,136,0,10,0,234,0,45,0,177,0,153,0,231,0,168,0,189,0,8,0,16,0,69,0,0,0,159,0,0,0,145,0,158,0,154,0,153,0,103,0,17,0,177,0,0,0,0,0,200,0,56,0,73,0,133,0,136,0,147,0,188,0,0,0,229,0,87,0,205,0,170,0,114,0,0,0,79,0,155,0,0,0,70,0,0,0,56,0,182,0,109,0,0,0,195,0,254,0,160,0,135,0,13,0,166,0,67,0,87,0,35,0,170,0,38,0,144,0,0,0,0,0,0,0,0,0,42,0,210,0,0,0);
signal scenario_full  : scenario_type := (116,31,211,31,211,30,182,31,104,31,50,31,50,30,29,31,29,30,28,31,34,31,34,30,222,31,64,31,244,31,13,31,252,31,234,31,234,30,73,31,3,31,155,31,57,31,94,31,20,31,15,31,16,31,252,31,124,31,89,31,255,31,36,31,36,30,92,31,192,31,64,31,64,30,64,29,141,31,130,31,130,30,229,31,223,31,223,30,147,31,153,31,174,31,174,30,246,31,84,31,115,31,107,31,107,30,107,29,233,31,217,31,147,31,147,30,232,31,227,31,226,31,180,31,194,31,51,31,159,31,254,31,254,30,254,29,112,31,204,31,133,31,124,31,32,31,32,30,85,31,63,31,153,31,239,31,239,30,164,31,122,31,255,31,237,31,34,31,154,31,243,31,114,31,43,31,157,31,67,31,218,31,218,30,120,31,154,31,254,31,62,31,62,30,115,31,159,31,104,31,154,31,239,31,13,31,231,31,8,31,8,30,8,29,28,31,214,31,236,31,156,31,73,31,5,31,141,31,242,31,161,31,141,31,141,30,223,31,243,31,64,31,163,31,229,31,229,30,126,31,21,31,59,31,155,31,132,31,163,31,47,31,43,31,18,31,199,31,199,30,180,31,109,31,128,31,151,31,151,30,145,31,132,31,243,31,70,31,70,30,197,31,73,31,73,30,4,31,189,31,234,31,234,30,234,29,234,28,79,31,133,31,34,31,7,31,91,31,135,31,135,30,229,31,229,30,122,31,21,31,170,31,161,31,89,31,89,30,249,31,249,30,249,29,161,31,217,31,192,31,192,30,38,31,166,31,153,31,171,31,10,31,112,31,162,31,54,31,206,31,71,31,150,31,230,31,230,30,170,31,249,31,154,31,164,31,90,31,90,30,36,31,108,31,8,31,180,31,155,31,137,31,138,31,22,31,154,31,188,31,188,30,173,31,173,30,173,29,235,31,152,31,109,31,196,31,156,31,155,31,88,31,137,31,12,31,151,31,81,31,81,30,240,31,58,31,88,31,142,31,253,31,196,31,196,30,196,29,196,28,64,31,144,31,142,31,243,31,243,30,166,31,166,30,197,31,165,31,171,31,100,31,100,30,100,29,246,31,246,30,93,31,74,31,47,31,121,31,172,31,19,31,58,31,81,31,12,31,12,30,59,31,135,31,135,30,135,29,170,31,65,31,213,31,213,30,213,29,72,31,106,31,74,31,230,31,41,31,120,31,120,30,146,31,224,31,123,31,123,30,35,31,184,31,229,31,89,31,172,31,57,31,57,30,199,31,46,31,163,31,108,31,20,31,170,31,25,31,233,31,233,30,85,31,188,31,188,30,250,31,201,31,201,30,240,31,210,31,174,31,176,31,144,31,204,31,32,31,83,31,5,31,71,31,188,31,188,30,79,31,4,31,8,31,131,31,131,30,197,31,98,31,234,31,22,31,98,31,20,31,94,31,69,31,179,31,179,30,141,31,9,31,118,31,64,31,181,31,60,31,32,31,32,30,156,31,156,30,155,31,105,31,224,31,105,31,66,31,249,31,34,31,219,31,219,30,219,29,178,31,178,30,254,31,216,31,27,31,10,31,137,31,208,31,208,30,208,29,208,28,211,31,134,31,195,31,195,30,195,29,73,31,235,31,195,31,161,31,161,30,191,31,177,31,35,31,77,31,59,31,59,30,194,31,203,31,70,31,175,31,16,31,222,31,155,31,52,31,160,31,191,31,180,31,15,31,51,31,253,31,59,31,59,30,66,31,195,31,120,31,37,31,37,30,153,31,153,30,173,31,161,31,129,31,68,31,13,31,198,31,198,30,249,31,113,31,113,30,116,31,34,31,34,30,203,31,148,31,167,31,231,31,57,31,243,31,82,31,11,31,214,31,42,31,193,31,19,31,52,31,76,31,76,30,76,29,76,28,229,31,149,31,145,31,145,30,222,31,208,31,222,31,182,31,65,31,65,30,81,31,39,31,39,31,177,31,143,31,201,31,218,31,218,30,29,31,29,30,48,31,132,31,14,31,185,31,48,31,120,31,170,31,238,31,183,31,199,31,199,30,181,31,214,31,206,31,206,30,117,31,117,30,115,31,71,31,75,31,203,31,203,30,207,31,173,31,173,30,70,31,219,31,86,31,86,30,94,31,56,31,55,31,95,31,250,31,101,31,223,31,24,31,90,31,59,31,115,31,184,31,189,31,119,31,220,31,120,31,143,31,143,30,143,29,143,28,218,31,232,31,208,31,85,31,85,30,135,31,135,30,156,31,151,31,157,31,157,30,157,29,87,31,89,31,14,31,227,31,241,31,241,30,241,31,241,30,103,31,130,31,130,30,185,31,9,31,95,31,177,31,103,31,66,31,159,31,47,31,63,31,45,31,45,30,195,31,139,31,139,30,135,31,8,31,8,30,8,29,222,31,19,31,86,31,229,31,159,31,125,31,108,31,223,31,210,31,45,31,45,30,25,31,136,31,10,31,234,31,45,31,177,31,153,31,231,31,168,31,189,31,8,31,16,31,69,31,69,30,159,31,159,30,145,31,158,31,154,31,153,31,103,31,17,31,177,31,177,30,177,29,200,31,56,31,73,31,133,31,136,31,147,31,188,31,188,30,229,31,87,31,205,31,170,31,114,31,114,30,79,31,155,31,155,30,70,31,70,30,56,31,182,31,109,31,109,30,195,31,254,31,160,31,135,31,13,31,166,31,67,31,87,31,35,31,170,31,38,31,144,31,144,30,144,29,144,28,144,27,42,31,210,31,210,30);

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
